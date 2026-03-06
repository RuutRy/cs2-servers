# cs2-servers

Terraform scripts to run CS2 servers.

> **Note:** As of March 2026, the servers run in **Ddsv5** virtual machines on Azure. Terraform is executed via GitHub DevOps pipelines; you don’t run `terraform` locally—the pipeline handles plan/apply and manages the Azure infrastructure. The VMs use Ubuntu 22.04 LTS and are configured to run the latest version of CS2.

## Quick start

1. Clone the repository.
2. Create a new branch for your changes.
3. Update [`main.tf`](./main.tf) with your desired configuration (e.g. number of servers, region, etc.).
4. Edit the MatchUp plugin version in [`infra/config/userdata.tftpl`](./infra/config/userdata.tftpl) to the latest release available on GitHub: <https://github.com/Juksuu/MatchUp>. The compose file pulls `juksuu/cs2:matchup`, which already bundles the plugin, so the local `docker_images` directory isn’t used by this project and can be considered redundant.
5. Commit your changes and push to your branch.
6. Create a pull request to merge your changes into the `main` branch.
7. Once the pull request is approved and merged, the GitHub DevOps pipeline will automatically deploy the changes to Azure.

## Changing amount of servers

To edit how many servers are running, modify the `servers` map in [`main.tf`](./main.tf):

```hcl
servers = {
    cs1 = { size = "Standard_D4ds_v5" },
    cs2 = { size = "Standard_D4ds_v5" },
    cs3 = { size = "Standard_D4ds_v5" },
    cs4 = { size = "Standard_D4ds_v5" },
}
```

In the example above, there are four servers defined. Add or remove entries to change the count.

To temporarily stop all servers, comment out the `servers` map and run the pipeline. This stops the machines but retains the infrastructure state. Uncomment the map and rerun the pipeline to start them again.

> **Note:** The only configuration you ever need to edit manually is `main.tf` (or files it includes) and `infra/config/userdata.tftpl`. All other directories—including `docker_images`—are unused by the pipeline; they exist as legacy artifacts and can be ignored or removed.