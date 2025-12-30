# CityU-Hall-Laundry-Stats

This repository:
1. Deploys n8n to fetch the CityU laundry status and stores it in MongoDB
2. Visualizes the data with Grafana

> [!TIP]
> The dashboard is not implemented yet! Feel free to contribute!


## Prerequisites

- Docker

## Installation

1. Run the commands to start and initialize the containers:

```bash
make init-env
make start
```

2. Configure n8n

   Access the n8n Web UI at [http://localhost:5679](http://localhost:5679) (or use the port you manually edited in `./compose.yaml`).

   - Initialize your n8n account
   - Import the workflows and credentials:

   ```bash
   make init-n8n
   ```

3. Activate the workflow in the n8n Web UI

> [!NOTE]
> The default trigger interval is 1 minute. Edit it if you want to save resources.

4. View the dashboard

   Access the Grafana at [http://localhost:3001](http://localhost:3001)

## Remove All Data

> [!WARNING]
> **Warning:** This command removes the containers and volumes (including all data in MongoDB).

```bash
make clear-env
```
