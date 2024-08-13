## Project: Comprehensive AWS S3 Management and Static Website Hosting

### Objective
This project involves creating and managing an AWS S3 bucket for TechVista Inc., which hosts a static website displaying their product portfolio. The project includes managing S3 storage classes, lifecycle policies, bucket policies, ACLs, and hosting a static website on S3. The goal is to optimize storage costs and ensure secure access to the content.

## Project Steps and Deliverables

### 1. Create and Configure an S3 Bucket

**1. Create an S3 Bucket**
- **Name:** `techvista-portfolio-[your-initials]`
- **Region:** Choose a region closest to the target audience.

**2. Enable Versioning**
- Navigate to the bucket's **Properties** tab.
- Enable **Versioning** to keep multiple versions of objects.

![alt text](<images/Screenshot from 2024-08-13 16-21-10.png>)
![alt text](<images/Screenshot from 2024-08-13 16-21-55.png>)
---


**3. Set Up Static Website Hosting**
- Go to the **Properties** tab.
- Enable **Static website hosting**.
- Set **Index Document** to `index.html` and **Error Document** to `error.html` (if applicable).

![alt text](<images/Screenshot from 2024-08-13 17-07-49.png>)
---


**4. Upload Static Website Files**
- Upload provided static website files (HTML, CSS, images) via the **Objects** tab.

![alt text](<images/Screenshot from 2024-08-13 15-53-54.png>)
---


**5. Ensure Website Accessibility**
- Use the **Bucket Website Endpoint** URL provided in the **Properties** tab to access and verify the website.

![alt text](<images/Screenshot from 2024-08-13 16-01-38.png>)
---


### 2. Implement S3 Storage Classes
+ Classify the uploaded content into different S3 storage classes (e.g., Standard, Intelligent-Tiering, Glacier).
+ Justify your choice of storage class for each type of content (e.g., HTML/CSS files vs. images).

![alt text](<images/Screenshot from 2024-08-13 16-20-16.png>)
![alt text](<images/Screenshot from 2024-08-13 16-20-39.png>)
---


### 3. Lifecycle Management

+ Create a lifecycle policy that transitions older versions of objects to a more cost-effective storage class (e.g., Standard to Glacier).

![alt text](<images/Screenshot from 2024-08-13 16-25-21.png>)
![alt text](<images/Screenshot from 2024-08-13 16-26-12.png>)
---


+ Set up a policy to delete non-current versions of objects after 90 days.

![alt text](<images/Screenshot from 2024-08-13 16-27-05.png>)
---


+ Verify that the lifecycle rules are correctly applied.

![alt text](<images/Screenshot from 2024-08-13 16-29-03.png>)
---


### 4. Configure Bucket Policies and ACLs

+ website content.
+ Restrict access to the S3 management console for specific IAM users using the bucket policy.
+ Set up an ACL to allow a specific external user access to only a particular folder within the bucket.

![alt text](<images/Screenshot from 2024-08-13 16-32-21.png>)
---
