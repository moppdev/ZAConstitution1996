![image](https://github.com/user-attachments/assets/419fe44e-d617-4f13-9c53-9d43ca63f33f)# ZAConstitution1996

![.NET](https://img.shields.io/badge/.NET-512BD4.svg?style=for-the-badge&logo=dotnet&logoColor=white)
![Swagger](https://img.shields.io/badge/Swagger-85EA2D.svg?style=for-the-badge&logo=Swagger&logoColor=black)

## Table of Contents

- [Description and Background](#description-and-background)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
  - [Database](#database)
  - [API](#api)
- [Contributing](#contributing)
- [License](#license)

## Description and Background

**ZAConstitution1996** is an ASP.NET Web API project that envisions providing public, on-demand, easy access to the contents of South Africa's 1996 Constitution that is currently in force. The goal of this project is to make the Constitution easily accessible to developers to create solutions that make it easier for the public to access and understand its contents.

**The inspiration for this** came from my own struggles to look up sections of the Constitution whenever they were mentioned in the news, whether about court cases or controversial Bills like the Expropriation Act. I often had to rely on my hard copy of the Constitution (which not everyone has) or find a government-hosted PDF version (which isn’t always reliable or easy to navigate).

I thought it was quite the schlep to do, so I wondered, "Isn't there an easier way to do this?". I searched GitHub and found a few Markdown versions of the Constitution, but they didn’t really solve the accessibility issue. **I decided to build this API and a companion website, which I will begin developing in due course.**

## Tech Stack

- .NET 9
- C# with ASP.NET Core Web API
- Entity Framework Core
- SQL Server
- Serilog
- Swagger

## Getting Started

### Database

Find the T-SQL scripts ```procedures.sql``` (creates stored procedures used in the API) and ```constitution.sql``` (creates and seeds the database) in the **SQLServerScripts** folder in this repository.

I used **SQL Server Management Studio (SSMS)** to create and run these scripts although you're welcome to use any other method to run these scripts on your local **SQL Server** instance.

### API

First off, **clone** this repository via entering the following in your terminal of choice:

```bash
git clone https://github.com/moppdev/ZAConstitution1996.git
```

**Navigate to** the folder where the repository has been cloned to, and **then** to the Constitution1996 folder:

```bash
cd ZAConstitution1996/Constitution1996API
```

Run the following command **to install packages**:

```bash
dotnet restore
```

To run the API, **run the following command**:

```bash
dotnet watch run
```

It should open a tab in your default browser on your local machine at ```http://localhost:5056``` and **route to the Swagger documentation** automatically.

## Contributing

Pull requests are welcome. Please check **[contribution.md](https://github.com/moppdev/ZAConstitution1996/blob/dev/CONTRIBUTING.md)** for more information.

## License

This project is licensed under the MIT License.
