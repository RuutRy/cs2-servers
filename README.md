# cs2-servers

Terraform scripts to run CS2 servers.

> **Note:** As of March 2026 the servers run in [**Standard_D4as_v7**](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/general-purpose/dasv7-series?tabs=sizebasic) virtual machines on Azure. Terraform is executed via GitHub DevOps pipelines; you don’t run `terraform` locally—the pipeline handles plan/apply and manages the Azure infrastructure. 
>
> * The VMs use **Ubuntu 24.04 LTS** (bumped from 22.04 march 2026).  When a newer LTS (26.04) becomes available in your region you can update `infra/module/virtual_machine/main.tf` accordingly.
> * Server instances always run the **latest CS2 build** via the `juksuu/cs2:matchup` image; there’s no version pin in this repo, so the container itself governs which CS2 revision is deployed.

## Quick start

1. Clone the repository.
2. Create a new branch for your changes.
3. Update [`main.tf`](./main.tf) with your desired configuration (e.g. number of servers, region, etc.).
4. Edit the MatchUp plugin version in [`infra/config/userdata.tftpl`](./infra/config/userdata.tftpl) to the latest release available on GitHub: <https://github.com/Juksuu/MatchUp>. The compose file pulls `juksuu/cs2:matchup`, which already bundles the plugin, so the local `docker_images` directory isn’t used by this project and can be considered redundant.
5. Commit your changes and push to your branch.
6. Create a pull request to merge your changes into the `main` branch.
7. Once the pull request is approved and merged, the GitHub DevOps pipeline will automatically deploy the changes to Azure.

> **Storage note:** the disk parameters live in
> [`infra/module/virtual_machine/main.tf`](./infra/module/virtual_machine/main.tf);
> check usage in a running machine with `df -h` or by inspecting Azure Monitor
> metrics. Valve’s dedicated‑server page (<https://developer.valvesoftware.com/wiki/Counter-Strike_2/Dedicated_Servers>)
> recommends **> 65 GB** of free space for CS2, so the Terraform `os_disk` size
> may need adjustment over time; disks can be enlarged without reprovisioning.

## Changing amount of servers

To edit how many servers are running, modify the `servers` map in [`main.tf`](./main.tf):

```hcl
servers = {
    cs1 = { size = "Standard_D4as_v7" },
    cs2 = { size = "Standard_D4as_v7" },
    cs3 = { size = "Standard_D4as_v7" },
    cs4 = { size = "Standard_D4as_v7" },
}
```

The example above defines one CS2 server. Add or remove entries to change the
count or to run additional instances (cs1/cs3/etc. are allowed but only
`cs2` is used by default).

To temporarily stop all servers, comment out the `servers` map and run the pipeline. This stops the machines but retains the infrastructure state. Uncomment the map and rerun the pipeline to start them again.

> **Note:** The only configuration you ever need to edit manually is `main.tf` (or files it includes) and `infra/config/userdata.tftpl`. All other directories—including `docker_images`—are unused by the pipeline; they exist as legacy artifacts and can be ignored or removed.