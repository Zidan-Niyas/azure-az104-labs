# Storage Concepts

1. Azure Blob Storage
    - Objects get stored as streams of binary data
    - This allows all types of files to be stored (images, python file, txt file etc..)
    - Each object that is uploaded to the blob storage has its own URL

2. Blob storage object access
    - By default we cant access an blob stored object url from our browser, to get access we can do the following
    storage account --> configurations --> Allow blob anonymous access (enable)
    storage account --> containers --> change access level --> Blob (anoynmous read access for blobs only)
    - This method of enabling anonymous access is not recommended, it is not a secure approach as everyone will be able to access this resource

3. Access Authorization
    - Anonymous access (not secure, authorization technique implemented in point 2)
    - Key authorization (each storage account gets two keys, they are like master passwords)
    - Shared access signature (temporary tokens for short term access to the resource)
    - Microsoft Entra ID (RBAC) 

4. Azure Storage Explorer
    - A central dashboard that can be used by anyone for working with the resources in an azure storage account
    - We can connect a storage account to the storage explorer using the access keys given in the storage account
    - We can upload, edit and delete objects via the storage explorer once a storage account has been connected to it