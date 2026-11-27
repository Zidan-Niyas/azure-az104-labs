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

8. Data Redundancy
    - Locally Redundant Storage (LRS): data object is replicated 3 times across the same data centre
    - Zone Redundant Storage (ZRS): data object is replicated across the 3 availability zones of the region
    - Geo Redundant Storage (GRS): data is replicated across a paired region, so that a region going down won't affect you data from being unavailable. This costs double the normal LRS (LRS is done twice in two regions)
    - Geo Zone Redundant Storage (GZRS): data is replicated across the 3 avalability zones in the primary region and also replicated to a secondary region

9. Blob Storage Lifecycle Management
    - We can define policies to transition blob storage objects between the different access tiers (Hot, Cool, Cold & Archive), based on the policy we setup
    - Eg:- we could setup a policy that says to transition the blob storage to cool access tier if it was last modified 30 days ago
    - This makes it easier to manage the lifecycle of storage blobs, instead of having to manually handle the access tiers and having to know which blobs are not being accessed and which can be moved from hot to cool or from cool to cold, we can just setup these policies that will handle them for us.
    - In the azure console: Storage Account --> Data Management --> Lifecycle Management --> Add a rule
    - If there are multiple rules for the same blob, it will perform the action that costs the least, 
        ie; delete < tierToCold < tierToCool, where delete costs the least, then tierToCold, then tierToCool, so delete action will be performed if all three rules exist for the same blob with same condition.

10. Blob Snapshots
    - Read-only copies of your blob storage 
    - A point-in-time copy that we can promote to be the live version if the resource like a code file changes
    - We can't delete a blob storage object if it has a snapshot, the snapshot will have to be deleted first.

11. Blob Versioning
    - Azure Console --> Storage Account --> Data Management --> Data protection --> Enable versioning
    - For every change you make to a blob, a version gets stored, this allows us to go back to previous versions of resources when needed

12. Blob Storage Object Replication
    - For replicating objects in a container in one storage account to another storage account
    - Prerequisites: 
        - Need to enable change feed in the source container
        - Need to enable versioning in both source and destination containers
    - Then, from source storage account, Data Management --> Object Replication --> Add replication rule

13. Soft Delete in File Shares
    - We can enable soft delete for a set amount of days (eg: 7 days) so that if someone accidently deletes the whole fileshare, it os recoverable for 7 days
    - This is an important feature for data protection

14. AzCopy tool
    - Used to work with azure storage accounts from the command line.
    - You can create containers, copy local files to containers etc. using the azopy cli tool
    - The tool needs to be installed on your machine before using it

15. Premium Storage Accounts
    - Storage accounts with low latency
    - No access tiers like hot, cool, cold or archive
    - Lifecycle management exists, but not for switching between acess tiers, only for deleting resources
    - Premium storage accounts only have locally redundant and zone redundant storage options (LRS and ZRS), no geo redundant storage (GRS not possible)