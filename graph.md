# Metrices For Infra Monitoring 
![image](https://github.com/user-attachments/assets/6129db77-bf51-472d-aa7a-c569cc97cd2e)

---

| Author | Created/Updated | Version  | Last updated by | Comments |
|--------|------------|----------|-----------------|----------------|
| Siddharth   | 30-07-2024   | 0.1| Siddharth          | Initial Doc       |

## Table Of Contents
1.  [Introduction](#introduction)
2.  [Objectives](#objectives)
3.  [Requirements for Infrastructure Monitoring](#requirements-for-infrastructure-monitoring)
4.  [Prerequisites](#prerequisites)
5.  [Aim](#aim)
6.  [Getting Started](#getting-started)
    - [Install Grafana](#install-grafana)
    - [Install Prometheus](#install-prometheus)
    - [Accessing Grafana](#accessing-grafana)
    - [Accessing Prometheus](#accessing-prometheus)
    - [Connections](#connections)
    - [Adding Data Source](#adding-data-source)
    - [Creating Dashboards](#creating-dashboards)
    - [Add CPU, Memory Metrics](#add-cpu-memory-metrics)
    - [Run Queries](#run-queries)
    - [Final Dashboard](#final-dashboard)
7.  [Conclusion](#conclusion)
8.  [Contact Information](#contact-information)
9.  [References](#references)

## Introduction

In this project, we will set up a robust monitoring system using Grafana and Prometheus to track CPU and memory utilization on EC2 instances. By monitoring these key metrics in real-time, we can identify performance bottlenecks, optimize resource allocation, and ensure the smooth operation of our infrastructure.

## Objectives

- Install and configure Prometheus and Grafana.
- Monitor EC2 instances for CPU and memory utilization.
- Create Grafana dashboards for visualizing these metrics.

## Requirements for Infrastructure Monitoring

- An Ubuntu Server instance (version 20.04 or later).
- SSH access to the server (Port 22 Open).
- At least 1 core CPU.
- Minimum 1 GB RAM.
- Minimum 2 GB of free disk space.
- Instance type: t2.micro.

## Prerequisites

| Resources                   | Description                        |
|-----------------------------|------------------------------------|
| **Ubuntu Server**           | Version 20.04 or later             |
| **SSH Access to the Server**| Port 22 Open                       |
| **CPU**                     | At least 1 core                    |
| **Memory**                  | Minimum 1 GB RAM                   |
| **Storage**                 | Minimum 2 GB of free disk space    |
| **Instance Type**           | t2.micro                           |

## Aim

The aim of this project is to set up a robust monitoring system using Grafana and Prometheus to track CPU and memory utilization on EC2 instances. By monitoring these key metrics in real-time, we can identify performance bottlenecks, optimize resource allocation, and ensure the smooth operation of our infrastructure.

## Getting Started 

### Install Grafana

1. **Update the system and install dependencies:**
    ```sh
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    ```
    ![Screenshot (332)](https://github.com/user-attachments/assets/b50f1413-8b9c-4fd4-929f-a7e58394c04e)

2. **Add the Grafana APT repository:**
    ```sh
    sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
    ```

3. **Add Grafana GPG key:**
    ```sh
    wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
    sudo apt-get update
    ```

4. **Install Grafana:**
    ```sh
    sudo apt-get install grafana
    ```

5. **Start and enable Grafana:**
    ```sh
    sudo systemctl start grafana-server
    sudo systemctl enable grafana-server
    ```

### Install Prometheus

1. **Install Prometheus:**
    ```sh
    sudo apt-get install prometheus
    ```

2. **Enable Prometheus:**
    ```sh
    sudo systemctl enable prometheus
    ```
    ![Screenshot (333)](https://github.com/user-attachments/assets/cd12786b-73dd-4dbe-9c55-8a973a915911)

### Accessing Grafana

We can access Grafana via browser by using our instance IP: `http://<instance-ip>:3000`.
![Screenshot (323)](https://github.com/user-attachments/assets/70ee0b48-43f2-438f-8279-48fb1da9139c)

### Accessing Prometheus

Prometheus can be accessed via browser by using our instance IP: `http://<instance-ip>:9090`.
![Screenshot (325)](https://github.com/user-attachments/assets/6668ac0e-3966-4d59-8a45-cb088fded9f6)

### Connections

These are the connections that we can monitor.
![Screenshot (339)](https://github.com/user-attachments/assets/7cd97800-3005-4701-990d-4cb654f4ee39)
![Screenshot (340)](https://github.com/user-attachments/assets/8799ed71-2335-4ab8-a544-48711e2c36bc)

### Adding Data Source 

1. **Navigate to Configuration -> Data Sources.**
    ![Screenshot (327)](https://github.com/user-attachments/assets/6f5be33e-08a3-4316-9d80-4ae534c6d38d)
2. **Click on "Add data source".**
    ![Screenshot (338)](https://github.com/user-attachments/assets/306cd1b6-2190-4507-a0a7-a7d885d8077e)
3. **Select "Prometheus" from the list.**
4. **Set the URL to `http://<your-prometheus-server-ip>:9090` and click "Save & Test".**

### Creating Dashboards

Design custom dashboards in Grafana to visualize CPU and memory utilization metrics. Customize graphs and panels to display relevant information in real-time.
![Screenshot (324)](https://github.com/user-attachments/assets/e8fb7d85-2886-4573-b302-0a901aed6c04)
![image](https://github.com/user-attachments/assets/bbe7c064-5604-4005-88c2-a810fd56d417) 
![Screenshot (328)](https://github.com/user-attachments/assets/473f3553-ae6b-42cf-b140-f3c7efb919af)

### Add CPU, Memory Metrics

1. **Navigate to your dashboard and click "Add Panel".**
2. **Run a query like `node_cpu_seconds_total` to get CPU metrics.**
3. **Run a query like `node_memory_MemAvailable_bytes` to get memory metrics.**
![image](https://github.com/user-attachments/assets/9e36956d-baa6-4089-88eb-71f53c24118a)

### Run Queries

1. **In the Grafana panel, add your desired queries to fetch CPU and memory metrics.**
    ![Screenshot (331)](https://github.com/user-attachments/assets/f6bb0f0d-a312-4fa6-b4ad-c6e4ec89130b)

2. **Now, add some stress to test your monitoring:**
    ```sh
    sudo apt-get install stress
    ```

### Final Dashboard 

This is how your final dashboard should look after configuring everything.
![Screenshot (336)](https://github.com/user-attachments/assets/c34b3fc6-1e1d-44bf-827b-b7473d428255)

### Conclusion

In conclusion, the implementation of Grafana and Prometheus for monitoring CPU and memory utilization on EC2 instances provides valuable insights into infrastructure performance. By visualizing and analyzing these metrics in real-time, organizations can proactively manage their resources, optimize performance, and ensure the smooth operation of their infrastructure. With the right monitoring tools and practices in place, businesses can stay ahead of potential issues and maintain a high level of reliability and efficiency.

## Contact Information

| Name          | Email Address                          | 
| ------------- |:--------------------------------------:|
| Siddharth      | siddharth.pawar.snaatak@mygurukulam.co |

## References 

| Links                                                                                           | Description                 | 
|-------------------------------------------------------------------------------------------------|-----------------------------|
| [Better Guide](https://betterstack.com/community/guides/monitoring/visualize-prometheus-metrics-grafana/) | For Information purpose     |
| [Grafana Implentation](https://grafana.com/docs/grafana/latest/)                               | For Grafana Implementation   |
