# Storage Concepts

1. Azure Blob Storage
    - Objects get stored as streams of binary data
    - This allows all types of files to be stored (images, python file, txt file etc..)
    - Each object that is uploaded to the blob storage has its own URL

2. Anonymous Blob storage object access
    - By default we cant access an blob stored object url from our browser, to get access we can do the following
    storage account --> configurations --> Allow blob anonymous access (enable)
    storage account --> containers --> change access level --> Blob (anoynmous read access for blobs only)
    - This method of enabling anonymous access is not recommended, it is not a secure approach as everyone will be able to access this resource

3. Access Authorization Techniques
    - Anonymous access (not secure, authorization technique implemented in point 2)
    - Key authorization (each storage account gets two keys, they are like master passwords)
    - Shared access signature (temporary tokens for short term access to the resource)
    - Microsoft Entra ID (RBAC) 

4. Azure Storage Explorer
    - A central dashboard that can be used by anyone for working with the resources in an azure storage account
    - We can connect a storage account to the storage explorer using the access keys given in the storage account
    - We can upload, edit and delete objects via the storage explorer once a storage account has been connected to it

5. Shared Access Signature (SAS)
    - Blob level: 
        - we can generate a SAS Token and URL for a specific blob with specified access duration (start and end time)
        - we can specify the permissions of the access signature (READ, CREATE, WRITE etc.)
        - the URL will be embed with the start and end time as well as the unique access signature string for that specific blob, allowing us to access the blob resource during that timeframe
    - Container level:
        - a container SAS token with read and list permission allows us to add the container to the azure storage explorer 
    - Storage account level:
        - a storage account SAS url will allow us to give the required permissions to the services, containers and objects in the storage account level and access these

6. Stored Access Policy
    - Basically a centralized permissions and start-stop time defined policy that can be attached onto a shared access signatures when we are creating one for a container.
    - Instead of defining the permissions when creating the SAS, we can just attach these pre-defined stored access policies.
    - eg:- ReadListPolicy (read and list permissions added) 
            Then, when creating a Shared Access Signature for a storage account container, use the ReadListPolicy, which gives the SAS URL the read and list permissions.
    - This access policy can be created only at the container level, not at the blob or storage account level.
    - It provides a centralized place for managing the permissions that are assigned to shared access signatures.

7. Immutable Blob Storage Policy
    - Allows us to define policies that makes edit/delete not possible for a set amount of days.
    - When this policy gets attached to a shared access token, the person accessing the resource wont be able to make any changes to the resource based on the immutable time defined in the policy