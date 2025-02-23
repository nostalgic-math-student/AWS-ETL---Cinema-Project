# Xideral-IntegratorProject
### Pitch PPT 
https://www.canva.com/design/DAGfuvNV7fQ/gYF8P0ALwmMXaTYGCEHugw/edit?utm_content=DAGfuvNV7fQ&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

![DiagramIntegrator](https://github.com/user-attachments/assets/bf96519b-34fc-45a0-a375-6a117f47e198)

## Idea:

The main Idea revolves around acomplishing objective in the most straight-forward manner: Create useful dashboards with metrics specified by Business Team at cinema.

This objective needs a solution which can scale to whatever metrics are required at any given point, but is resillient enough to handle big loads of data constantly. 

## Services

This architecture solution proposes 3 key services AWS offers: 

- **AWS Glue** for **ETL** process:
  - We use **Glue Crawlers** to parse data from Data Sources like MySQL Database (CRM / ECR) and POS Data entries
  - Parsed data is stored in a **Glue Catalog Database** ensuring all data is centralized and structured
  - Finally, an AWS Glue Job processes the extracted data into multiple tables to meet business requirements.
_**Note: A multipurpose S3 Bucket is used for backup,logging and temporary data storage during job execution**_

- **AWS DynamoDB** & **AWS Athena** for Data Manipulation:
  - **DynamoDB** stores processed data in modular metric tables, ensuring the architecture remains **scalable** and **adaptable**
  - An **Athena Workgroup** is set up for real time Data querying
  - Athena queries use the **Multipurpose S3 Bucket** service mentioned previously **AWS Glue** as a caching layer for queries generated, optimizing performance

- **AWS Quicksight** for Data Visualization
  - Athena service data is exposed to **AWS Quicksight** as a Data Source, allowing dynamic dashboard creation.
  - A variety of visual representations are built using Athena-queried data, making key insights easily accessible to business users
 
  ## Advantages

- **Scalability**: This architecture is designed to grow through **AWS Glue** and **AWS Athena** services as data and metric requirements evolve.
- **Modularity & Flexibility** : As this architecture states from previous explanation, each component serves a specific role which can be adapted to business needs.
- **Cost-efficiency** : As the infrastructure has its key services in serverless execution environments, we can ensure cost-efficiency with its scalable charge plans (we discuss cost description later). For example:
  - **Athena** service charges only for queries executed, for which we have a caching S3 minimizing cost impact.
  - **Glue** service runs serverless and charges on runtime, which can infer pricing scales with data volume.
  - **S3** service in this configuration serves a basic role for relative small to medium efficient storage for logs and cached queries.

## Challenges

- Athena's query latency can be slower compared to other data manipulation tools, but as the solution proposed doesn't require high time precision between queries we choose this for the sake of modularity.
- S3 instance can be a naive straightforward solution for logging, but this project is intended as a demo solution and preferably a much more developed pipeline would choose **CloudTrail Logs** as preferred logging.
- AWS Jobs can get faster and thus cheaper with a proper implementation. This demo serves as a schematic and not as a final solution as this step can be further optimized.

## Cost breakdown

We will assume certain values (data flow, users, etc) to visualize a much more clear example in cost description.
Also, we assume Raw data sources (DB, S3, Lambda, etc...) are left out of the infrastructure cost as customer provides this resources.

### AWS Glue

#### Jobs
As a rough assumption, in practice Glue jobs last max. 1 minute execution per metric, ranging from 3-5 min runtime per job run.
As the job is ran on a 2 hour basis: 5 * 30 * 12 = 1800 min / month

<img width="470" alt="image" src="https://github.com/user-attachments/assets/ed1b560a-ae1a-4076-a7c0-e3f6e4b8d33d" />

**Job sessions** estimate: 66.07 USD / month

#### Data Catalog

Data flow from POS is 200 units per 2 hours average (as this is a demo, we assume average=exact inflow), 2400 per day, 72,000 items per month.
Data flow from CRM + ECR is no much more than 10% from POS data (as POS data presents 20 users per file) , so we assume a hard cap for 14,000 units of data per month.
Current demo environment has an estimate of 2x the processing space allocated as Glue Jobs check processed and incoming data (room for improvement)
then, Data Catalog must persist up to 172,000 units of objects stored monthly.

<img width="563" alt="image" src="https://github.com/user-attachments/assets/49be4aab-d902-4db4-879a-b4987d6ac523" />
**Data Catalog storage** estimate: 1.89 USD / month

#### Crawlers

As testing shows, crawlers for this volume of data last no longer than 2 minutes per execution. At a schedule rate of 2 hours per execution we assume 1440 max runtime for crawlers each month.

<img width="523" alt="image" src="https://github.com/user-attachments/assets/506e85d7-0c75-4d25-b9cf-1a5df0fc56eb" />
**Crawler execution time** estimate: 21.12 USD / month

**Total AWS Glue** cost estimate: 94.58 USD / month

### DynamoDB

As processed data through Glue becomes thin as small values, we will see that hard caps assure a negligible cost so we start with an on-demand setup:

#### Storage Allocate
Most heavy item in all 5 tables handles on average 54 bytes of data, to calculate handled data hard cap per month:
54 bytes * 5 tables * 200 items max POS input * 12 daily executions (2-hour basis) * 30 days in month = 19,440,000 bytes max storaged = 0.01944 GB

Then we allocate at least 1GB for DynamoDB.

<img width="305" alt="image" src="https://github.com/user-attachments/assets/d8f62198-de9e-4be3-b7da-ee93965ba0f1" />
#### Data writing
Using a Write Request Unit (WRU) calculation based on data input flow we calculate at most 19000 WRUs which calculate this cost:

<img width="921" alt="image" src="https://github.com/user-attachments/assets/0c728fda-6f64-4c69-a0b5-25b24a41a3d2" />
#### Data reading
Assuming a max outflow of data thanks to Athena Querying :
<img width="1079" alt="image" src="https://github.com/user-attachments/assets/cbb7813f-1ccd-48e3-8ce6-24fb1ca6f923" />
#### Total estimate
<img width="304" alt="image" src="https://github.com/user-attachments/assets/01dc98b7-9ea1-445d-8271-0e3237183608" />
### AWS Athena

As this service works with a low mainteinance data from DynamoDB we can assure this hard cap for cost, running 12 times per day:
<img width="558" alt="image" src="https://github.com/user-attachments/assets/bd114591-c6e6-400b-a832-d8bf06a208a1" />

### AWS Quicksight 

Assuming a small set of business team users with access to dashboard (4) we calculate a 30 USD per month billing

<img width="179" alt="image" src="https://github.com/user-attachments/assets/730d608b-5e8d-4b98-a4cd-ef143076e378" />

### S3 Instance

We assume a 10GB On Demand bucket instance :

<img width="193" alt="image" src="https://github.com/user-attachments/assets/77abed22-f985-4b24-8239-b176f775c3ae" />

### Total cost estimate: 

<img width="1538" alt="image" src="https://github.com/user-attachments/assets/cbe3605c-bd0e-4b9e-96a5-74b40e55cb15" />

Cost per month: **125.87 USD**



