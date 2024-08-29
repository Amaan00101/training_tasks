## Grafana Installation from APT Repository

This guide provides step-by-step instructions for installing Grafana from the APT repository on a Debian-based system (e.g., Ubuntu).

## Prerequisites

- Ensure your system is updated and has access to the internet.
- You should have `sudo` privileges.

### 1. Install Prerequisite Packages

Before installing Grafana, you'll need to install some prerequisite packages. Run the following command:

```
sudo apt-get install -y apt-transport-https software-properties-common wget
```

### 2. Import the GPG Key

Import the Grafana GPG key to ensure the authenticity of the packages:

```
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```

### 3. Add the Grafana APT Repository

#### For Stable Releases

Add the repository for stable releases with the following command:

```
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```


### 4. Update the List of Available Packages

Update your package list to include the new Grafana repositories:

```
sudo apt-get update
```
![alt text](<images/Screenshot from 2024-08-28 23-12-08.png>)
---


### 5. Install Grafana

### To Install Grafana OSS (Open Source)

Run the following command to install the latest Grafana OSS release:

```
sudo apt-get install grafana
```
![alt text](<images/Screenshot from 2024-08-28 23-12-36.png>)
---


### To Install Grafana Enterprise

If you need Grafana Enterprise, use the following command:

```
sudo apt-get install grafana-enterprise
```
![alt text](<images/Screenshot from 2024-08-28 23-12-51.png>)
---


### 6. Start and Enable Grafana

Once Grafana is installed, start the service and enable it to start on boot:

```
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```
![alt text](<images/Screenshot from 2024-08-29 11-40-33.png>)
---


### 7. Access Grafana

Grafana will be available at `http://localhost:3000` by default. Open this URL in your web browser to access the Grafana web interface. The default login credentials are:

- **Username:** admin
- **Password:** admin

![alt text](<images/Screenshot from 2024-08-29 11-21-45.png>)
---