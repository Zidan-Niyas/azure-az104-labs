# Storage Concepts

1. Azure Blob Storage
    - Objects get stored as streams of binary data
    - This allows all types of files to be stored (images, python file, txt file etc..)
    - Each object that is uploaded to the blob storage has its own URL

2. Blob storage object access
    - By default we cant access an blob stored object url from our browser, to get access we can do the following
    storage account --> configurations --> Allow blob anonymous access (enable)
    storage account --> containers --> change access level --> Blob (anoynmous read access for blobs only)
    - This method of enabling anonymous access is not recommended