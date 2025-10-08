# DevOps Assessment – Next.js Container, GHCR & Minikube

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

- Workflow: `.github/workflows/publish-to-ghcr.yml` triggers on push to `main`
- Builds Docker image and pushes to GHCR:
	- `ghcr.io/<YOUR_GITHUB_USERNAME>/my-next-app:latest`
	- `ghcr.io/<YOUR_GITHUB_USERNAME>/my-next-app:<commit-sha>`

**Notes:**
- GHCR requires lowercase usernames and repository names
- If push fails, create a Personal Access Token (PAT) with `write:packages` and add it as `GHCR_PAT` secret

---

## 4. Kubernetes Deployment (Minikube)

**Manifests:** See `k8s/deployment.yaml` and `k8s/service.yaml`

**Deployment Example:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
	name: nextjs-deployment
	labels:
		app: nextjs
spec:
	replicas: 2
	selector:
		matchLabels:
			app: nextjs
	template:
		metadata:
			labels:
				app: nextjs
		spec:
			containers:
				- name: nextjs
					image: ghcr.io/<YOUR_GITHUB_USERNAME>/my-next-app:latest
					ports:
						- containerPort: 3000
					readinessProbe:
						httpGet:
							path: /
							port: 3000
						initialDelaySeconds: 5
						periodSeconds: 10
					livenessProbe:
						httpGet:
							path: /
							port: 3000
						initialDelaySeconds: 15
						periodSeconds: 20
```

**Service Example:**
```yaml
apiVersion: v1
kind: Service
metadata:
	name: nextjs-service
spec:
	selector:
		app: nextjs
	type: NodePort
	ports:
		- protocol: TCP
			port: 80
			targetPort: 3000
			nodePort: 30080
```

**Deploy to Minikube:**
```bash
minikube start
kubectl apply -f k8s/
kubectl get pods -w
minikube service nextjs-service --url
```
Access the app at the URL printed (e.g., `http://127.0.0.1:51454`)

> ⚠️ Keep the terminal open while using Docker driver on Windows

---

## 5. Submission Details

- GitHub Repository: `https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO>`
- GHCR Image: `ghcr.io/<YOUR_GITHUB_USERNAME>/my-next-app:latest`

---

## 6. Notes & Tips

- **Health checks:**  
	- `readinessProbe` ensures the pod is ready to accept traffic  
	- `livenessProbe` ensures the pod is alive
- Use lowercase for GitHub usernames and repo names in GHCR image tags
- Minikube NodePort allows local access to your app without exposing it to the public internet

---

Replace `<YOUR_GITHUB_USERNAME>` and `<YOUR_REPO>` with your actual GitHub username and repository name.

