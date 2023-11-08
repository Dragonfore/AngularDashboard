#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 5009
EXPOSE 4200

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["AngularExperimentation.csproj", "./"]
RUN dotnet restore "./AngularExperimentation.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AngularExperimentation.csproj" -c Release -o /app/build

# RUN apt-get update && \
#     apt-get install -y wget && \
#     apt-get install -y gnuph2 && \
#     wget -q0- https://dev.nodesource.com/setup_10.x | bash - && \
#     apt-get install -y build-essential nodejs
ENV NODE_VERSION=16.13.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

FROM build AS publish
RUN dotnet publish "AngularExperimentation.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AngularExperimentation.dll"]