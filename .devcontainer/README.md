# e_commerce

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Development Container

This project includes a devcontainer configuration, which allows you to develop in a consistent, pre-configured
environment.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  for VS Code

### Getting Started

1. **Clone the repository.**
2. **Open the repository in VS Code.**
3. **Reopen in Container:** VS Code should automatically detect the `.devcontainer/devcontainer.json` file and prompt
   you to "Reopen in Container". Click this button.
    * If you don't see the prompt, open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`) and search for "
      Remote-Containers: Reopen in Container".

This will build the Docker image (if it's the first time) and start the devcontainer. Your VS Code instance will then be
connected to this containerized environment.

### Environment

The devcontainer is configured with:

- Java 21
- Bun (latest version)
- Common development tools

### Customization

- **VS Code Extensions:** You can add your preferred VS Code extensions to the `extensions` array in
  `.devcontainer/devcontainer.json`.
- **Port Forwarding:** If your application uses specific ports, add them to the `forwardPorts` array in
  `.devcontainer/devcontainer.json`. For example, to forward port 8080 for your backend and 3000 for your frontend:
  ```json
  "forwardPorts": [8080, 3000],
  ```
- **Other Dependencies:** If you need additional software or tools, you can modify the `.devcontainer/Dockerfile` to
  include them.

### Troubleshooting

- If you encounter issues building the container, check the Docker build logs for errors.
- Ensure Docker Desktop is running.
- If you made changes to `devcontainer.json` or `Dockerfile` after the container was built, you might need to rebuild
  the container. Open the Command Palette and search for "Remote-Containers: Rebuild Container".
