# Azure AD B2C Setup

We have created Gallery3 Open ID Module that adds Facebook, and Microsoft Account functionality to the login page using Azure AD B2C
In this module, you'll create Azure AD B2C Directory, register your application (Gallery3), create sign-in/sing-out policy, configure identity providers(Microsoft, Facebook, or both).
 
## Create Azure AD B2C Directory

If you don't have Azure AD B2C Directory (tenant), create a B2C directory. Here is an instruction:
[Create an Azure Active Directory B2C tenant in the Azure portal](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-get-started)

## Register the Gallery3 application in your Azure AD B2C directory

Register your Gallery3 application in your Azure AD B2C directory. Here is an instruction:
[Azure Active Directory B2C: Register your application](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-app-registration)

## Configure Identity Providers (Microsoft, Facebook, or both)

Please configure either Microsoft account, Facebook, or both as identity providers in your tenant
- Microsoft Account (only if you want to configure Mcrosoft account)
  - Please configure this by following instruction: [Azure Active Directory B2C: Provide sign-up and sign-in to consumers with Microsoft accounts](https://docs.microsoft.com/ja-jp/azure/active-directory-b2c/active-directory-b2c-setup-msa-app)

- Facebook Account (only if you want to configure Facebook account)
  - Please configure this by following instruction: [Azure Active Directory B2C: Provide sign-up and sign-in to consumers with Facebook accounts](https://docs.microsoft.com/ja-jp/azure/active-directory-b2c/active-directory-b2c-setup-fb-app)

## Create sign-in/sing-out policy

Please create sign-in/sing-out policies that can handles both consumer sign-up & sign-in experiences. If you have mulitple identity providers in your tenant with which you want to handle sign-up & sign-in experiences, create a policy for each identity provider:

Here is an instruction: [Create a sign-up or sign-in policy](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-reference-policies#create-a-sign-up-or-sign-in-policy)

