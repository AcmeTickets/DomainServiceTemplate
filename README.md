# Domain Service Template

This repository provides a fully templatized .NET solution for building domain-driven microservices. It includes an API service and a Message service, with communication between them handled via NServiceBus. The template is designed for rapid customization to your own domain using a single PowerShell script.

## Features
- **API Service**: A RESTful API for your domain, ready for extension.
- **Message Service**: A background service for handling domain events and asynchronous processing.
- **NServiceBus Integration**: Reliable messaging between API and Message services.
- **Cosmos DB Ready**: Easily configure your Cosmos DB account via environment variables.
- **Configurable Ports**: Set custom ports for API and Message services.
- **Easy Domain Customization**: Rename all namespaces, folders, and configuration values to your domain with a single script.

## Getting Started

### 1. Clone the Repository
```sh
git clone <this-repo-url>
cd DomainServiceTemplate
```


### 2. Apply Your Domain
Run the PowerShell script in the root directory to set your domain name, short name, ports, and Cosmos DB account:


Run from powershell without having the project open.

```powershell
# Example usage:
.\Apply-DomainTemplate.ps1 -DomainName "YourDomainName" -DomainShortName "yourshortname" -ApiPort "5001" -MsgPort "5002"
```
- `DomainName`: PascalCase name for your domain (e.g., `OrderManagement`)
- `DomainShortName`: Lowercase or short name (e.g., `order`)
- `ApiPort`: (Optional) Port for the API service (default: 5271)
- `MsgPort`: (Optional) Port for the Message service (default: 5281)

This script will:
- Replace all template variables in file contents
- Rename folders and files to match your domain
- Update configuration and workflow files

#### 2a. Update the CICD File
Open the project in VSCode and run this prompt in GitHub Copilot

Replace all template placeholders in the file CICD-Pipeline.yml as follows:

Replace every occurrence of {{DomainName}} with HumanResources
Replace every occurrence of {{DomainShortName}} with humanrsr
Replace every occurrence of {{api_port}} with 5275
Replace every occurrence of {{msg_port}} with 5276
Only update these placeholders—do not change any other content or formatting in the file.

### 3. Configure Environment Variables
Set your Cosmos DB account and other secrets as needed. For example, update `appsettings.Development.json` with your `AccountKey` and other values.

### 4. Build and Run
Use the provided Dockerfiles or run locally with .NET CLI:
```sh
dotnet build src/Api/Api.csproj
dotnet run --project src/Api/Api.csproj

dotnet build src/Message/Message.csproj
dotnet run --project src/Message/Message.csproj
```

### 5. CI/CD
The template includes GitHub Actions workflows for building and deploying both services as container apps. Ports and image names are fully configurable.

#### 5a.
Have the platform team add your domain to the head script
Add your domain specific resources to a new script that is called by the head script
https://github.com/AcmeTickets/Platform/tree/main/.github

#### 5b.
Create a federated Id so that your repo can deploy the code to Azure. 

## Architecture
- **API Service**: Handles HTTP requests, domain commands, and publishes events.
- **Message Service**: Listens for domain events and processes them asynchronously.
- **NServiceBus**: Used for reliable messaging between services.
- **Cosmos DB**: Used as the default persistence layer (configurable).

## Best Practices
- Use the PowerShell script for all renaming and configuration to avoid manual errors.
- Keep secrets and connection strings out of source control.
- Extend the API and Message services by adding new commands, events, and handlers in their respective folders.
- Use the provided CI/CD workflows as a starting point for your own automation.

## License
See `License.xml` for details.

---

For questions or contributions, please open an issue or pull request.