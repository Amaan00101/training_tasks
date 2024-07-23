## Task - Day 11

### Project Overview - Create a private git repo that has a maven project. In Jenkins create 2 freestyle project, one to compile that maven project and other to test that maven project. Create a pipeline view of the project.

#### Step 1. Private Git Repo


+ Creating private git repo and push the code


![alt text](<Screenshot from 2024-07-23 22-34-44.png>)
---

#### Step 2. Compile maven project

+ Creating new freestyle project "dev_compile"


![alt text](1.png)
---

+ Setting up and Configuring git credentails in jenkins


![alt text](4.png)
---

+ Setup Maven Installation in Jenkins


![alt text](3.png)
---

+ Setup Maven Build Steps COMPILE


![alt text](5.png)
---

+ Build "dev_compile" Project


![alt text](8.png)

![alt text](10.png)
---

#### Step 3. Test maven project

+ Creating another Freestyle Project "dev_test"


![alt text](2.png)
---

+ Setup Maven Build Steps TEST


![alt text](7.png)
---


+ Build "dev_test" Project


![alt text](9.png)

![alt text](11.png)

![alt text](12.png)
---

#### Step 4. Pipeline view

+ Create new "build pipeline" in jenkins


![alt text](<Screenshot from 2024-07-23 22-52-35.png>)
---


+ Fill the details


![alt text](<Screenshot from 2024-07-23 22-37-22.png>)

![alt text](<Screenshot from 2024-07-23 22-29-08.png>)
---


+ Final Output of Pipeline view


![alt text](<Screenshot from 2024-07-23 22-23-00.png>)
---