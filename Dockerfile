# base image from dotnet 7.0
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
#/app folder in my container
WORKDIR /app
#copy csproj(the source code) to root directory
COPY HelloWorld/*.csproj ./
#restore all the dependencies in my application (if we cant restore we have problem and we stop here)
RUN dotnet restore

COPY HelloWorld/. ./
#Compiles and packages the application,Specifies Release mode,Outputs the published files to the out directory.
RUN dotnet publish -c Release -o out

#final image
FROM mcr.microsoft.com/dotnet/sdk:7.0
WORKDIR /app
#copy from first image to this image
COPY --from=build-env /app/out .
# specifies the command that will be run
ENTRYPOINT [ "dotnet", "HelloWorld.dll"]