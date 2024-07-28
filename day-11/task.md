## Task - Day 11

### Project Overview - Create a private git repo that has a maven project. In Jenkins create 2 freestyle project, one to compile that maven project and other to test that maven project. Create a pipeline view of the project.

#### Step 1. Private Git Repo


+ Creating private git repo and push the code


![alt text](images/0.png)
---

#### Step 2. Compile maven project

+ Creating new freestyle project "dev_compile"


![alt text](images/1.png)
---

+ Setting up and Configuring git credentails in jenkins


![alt text](images/4.png)
---

+ Setup Maven Installation in Jenkins


![alt text](images/3.png)
---

+ Setup Maven Build Steps COMPILE


![alt text](images/5.png)
---

+ Build "dev_compile" Project


![alt text](images/8.png)

![alt text](images/10.png)
---

#### Step 3. Test maven project

+ Creating another Freestyle Project "dev_test"


![alt text](images/2.png)
---

+ Setup Maven Build Steps TEST


![alt text](images/7.png)
---


+ Build "dev_test" Project


![alt text](images/9.png)

![alt text](images/11.png)

![alt text](images/12.png)
---

#### Step 4. Pipeline view

+ Create new "build pipeline" in jenkins


![alt text](images/13.png)
---


+ Fill the details


![alt text](images/14.png)

![alt text](images/15.png)
---


+ Final Output of Pipeline view


![alt text](images/16.png)
---