# DevOps Assessment - Next.js Container + GHCR + Minikube

## Project Overview

This project demonstrates:
- Containerizing a Next.js application with Docker
- Automating Docker image build and push to GitHub Container Registry (GHCR) using GitHub Actions
- Deploying the containerized app to Kubernetes (Minikube)

---

## 1. Local Setup

### Prerequisites

- Node.js 18+
- Docker
- kubectl
- Minikube

### Run Next.js App Locally

```bash
npm install
npm run dev
```
Open your browser at: [http://localhost:3000](http://localhost:3000)

---

## 2. Docker Build & Run Locally

**Build Docker Image:**
```bash
docker build -t my-next-app:local .
```

**Run Docker Container:**
```bash
docker run --rm -p 3000:3000 my-next-app:local
```
Open your browser at: [http://localhost:3000](http://localhost:3000)

---

## 3. GitHub Actions & GHCR

- Workflow triggers on push to `main` branch
- Builds Docker image and pushes to GHCR

**Image tags:**
- `ghcr.io/ngovindaraju/my-next-app:latest`
- `ghcr.io/ngovindaraju/my-next-app:<commit-sha>`

**Notes:**
- GHCR requires lowercase usernames and repository names
- If push fails, create a Personal Access Token (PAT) with `write:packages` and add it as `GHCR_PAT` secret

---

## 4. Kubernetes Deployment (Minikube)

**Deployment Steps:**

Start Minikube:
```bash
minikube start
```

Apply Kubernetes manifests stored in the project’s `k8s/` folder:
```bash
kubectl apply -f k8s/
kubectl get pods -w
```

Access the service:
```bash
minikube service nextjs-service --url
```
Example URL: `http://127.0.0.1:51454`

> ⚠️ Keep the terminal open if using Docker driver on Windows

**Note:**  
The `k8s/` folder contains deployment and service manifests, which handle replicas, ports, and health checks.
