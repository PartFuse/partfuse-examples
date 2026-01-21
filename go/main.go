package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

const defaultHost = "partfuse.p.rapidapi.com"
const defaultBaseURL = "https://partfuse.p.rapidapi.com"

type Client struct {
	APIKey  string
	Host    string
	BaseURL string
	HTTP    *http.Client
}

func NewClient() *Client {
	apiKey := os.Getenv("PARTFUSE_RAPIDAPI_KEY")
	if apiKey == "" {
		log.Fatal("Error: PARTFUSE_RAPIDAPI_KEY environment variable is required")
	}

	host := os.Getenv("PARTFUSE_RAPIDAPI_HOST")
	if host == "" {
		host = defaultHost
	}

	baseURL := os.Getenv("PARTFUSE_BASE_URL")
	if baseURL == "" {
		baseURL = defaultBaseURL
	}

	return &Client{
		APIKey:  apiKey,
		Host:    host,
		BaseURL: baseURL,
		HTTP:    &http.Client{Timeout: 10 * time.Second},
	}
}

func (c *Client) Request(method, path string, body io.Reader) ([]byte, error) {
	req, err := http.NewRequest(method, c.BaseURL+path, body)
	if err != nil {
		return nil, err
	}

	req.Header.Set("X-RapidAPI-Key", c.APIKey)
	req.Header.Set("X-RapidAPI-Host", c.Host)
	req.Header.Set("Content-Type", "application/json")

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode == 429 {
		log.Println("Rate limit exceeded")
	}

	if resp.StatusCode >= 400 {
		respBody, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("API error %d: %s", resp.StatusCode, string(respBody))
	}

	return io.ReadAll(resp.Body)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run main.go [search|compare|bom|health]")
		os.Exit(1)
	}

	client := NewClient()
	command := os.Args[1]

	switch command {
	case "search":
		searchCmd := flag.NewFlagSet("search", flag.ExitOnError)
		limit := searchCmd.Int("limit", 5, "Max results")
		searchCmd.Parse(os.Args[2:])
		
		if searchCmd.NArg() < 1 {
			fmt.Println("Usage: search <query> [--limit N]")
			os.Exit(1)
		}
		query := searchCmd.Arg(0)
		
		fmt.Printf("Searching for %s...\n", query)
		resp, err := client.Request("GET", fmt.Sprintf("/api/v1/search?q=%s&limit=%d", query, *limit), nil)
		handleResult(resp, err)

	case "compare":
		compareCmd := flag.NewFlagSet("compare", flag.ExitOnError)
		qty := compareCmd.Int("qty", 1, "Quantity")
		compareCmd.Parse(os.Args[2:])

		if compareCmd.NArg() < 1 {
			fmt.Println("Usage: compare <part_number> [--qty N]")
			os.Exit(1)
		}
		part := compareCmd.Arg(0)

		fmt.Printf("Comparing %s (Qty: %d)...\n", part, *qty)
		resp, err := client.Request("GET", fmt.Sprintf("/api/v1/compare/%s?qty=%d", part, *qty), nil)
		handleResult(resp, err)

	case "bom":
		// Simple embedded example for brevity
		fmt.Println("Sending sample BOM...")
		bom := map[string]interface{}{
			"lines": []map[string]interface{}{
				{"mpn": "NE555", "quantity": 10},
				{"mpn": "LM358", "quantity": 20},
			},
		}
		jsonBody, _ := json.Marshal(bom)
		resp, err := client.Request("POST", "/api/v1/bom/compare", bytes.NewBuffer(jsonBody))
		handleResult(resp, err)

	case "health":
		fmt.Println("Checking health...")
		resp, err := client.Request("GET", "/health", nil)
		handleResult(resp, err)

	default:
		fmt.Printf("Unknown command: %s\n", command)
		os.Exit(1)
	}
}

func handleResult(data []byte, err error) {
	if err != nil {
		log.Fatalf("Failed: %v", err)
	}
	var pretty bytes.Buffer
	json.Indent(&pretty, data, "", "  ")
	fmt.Println(pretty.String())
}
