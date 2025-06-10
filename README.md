## 🚀 Development Workflow

Welcome to the `dev` branch — **primary development branch**. This branch is the main integration point for all ongoing feature work and improvements.

### 📌 Branching Strategy

- **`main` branch**  
  - Always holds **production-ready** code.  
  - Only updated via **pull requests from `dev`**.  
  - No direct commits allowed.

- **`dev` branch** *(this branch)*  
  - Used for active development.  
  - New features and fixes are merged here first.  
  - Tested and stabilized before merging into `main`.

- **`feature/your-feature-name` branches**  
  - Created off of `dev`.  
  - Each feature or fix gets its own branch.  
  - Open a pull request to `dev` when completed.

### 🔁 Typical Workflow

1. Pull the latest `dev`:
   ```bash
   git checkout dev
   git pull origin dev

