# Modernize a Java Application

## Goal

Modernize the Asset Manager Java Spring Boot application for Azure deployment, migrating from AWS dependencies to Azure services using GitHub Copilot App Modernization in VS Code.

## Actions

**Environment Setup:**
1. Open Docker Desktop and ensure it's running
2 Open Terminal and run the setup commands:
   ```bash
   mkdir C:\gitrepos\lab
   cd C:\gitrepos\lab
   git clone https://github.com/crgarcia12/migrate-modernize-lab.git
   cd .\migrate-modernize-lab\src\AssetManager\
   code .
   ```
3. Login to GitHub from VS Code
4. Install GitHub Copilot App Modernization extension if not present

**Validate Application Locally:**

5. Open Terminal in VS Code (View → Terminal)
6. Run `scripts\startapp.cmd`
7. Wait for Docker containers (RabbitMQ, Postgres) to start
8. Allow network permissions when prompted
9. Verify application is accessible at http://localhost:8080
10. Stop the application by closing console windows

**Perform AppCAT Assessment:**

11. Open GitHub Copilot App Modernization extension in the Activity bar
12. Ensure Claude Sonnet 4.5 is selected as the model
13. Click "Migrate to Azure" to begin assessment
14. Wait for AppCAT CLI installation to complete
15. Review assessment progress in the VS Code terminal
16. Wait for assessment results (9 cloud readiness issues, 4 Java upgrade opportunities)

**Analyze Assessment Results:**

17. Review the assessment summary in GitHub Copilot chat
18. Examine issue prioritization:
    - Mandatory (Purple) - Critical blocking issues
    - Potential (Blue) - Performance optimizations
    - Optional (Gray) - Future improvements
19. Click on individual issues to see detailed recommendations
20. Focus on the AWS S3 to Azure Blob Storage migration finding

**Execute Guided Migration:**

21. Expand the "Migrate from AWS S3 to Azure Blob Storage" task
22. Read the explanation of why this migration is important
23. Click the "Run Task" button to start the migration
24. Review the generated migration plan in the chat window and `plan.md` file
25. Type "Continue" in the chat to begin code refactoring

**Monitor Migration Progress:**

26. Watch the GitHub Copilot chat for real-time status updates
27. Check the `progress.md` file for detailed change logs
28. Review file modifications as they occur:
    - `pom.xml` and `build.gradle` updates for Azure SDK dependencies
    - `application.properties` configuration changes
    - Spring Cloud Azure version properties
29. Allow any prompted operations during the migration

**Validate Migration:**

30. Wait for automated validation to complete:
    - CVE scanning for security vulnerabilities
    - Build validation
    - Consistency checks
    - Test execution
31. Review validation results in the chat window
32. Allow automated fixes if validation issues are detected
33. Confirm all validation stages pass successfully

**Test Modernized Application:**

34. Open Terminal in VS Code
35. Run `scripts\startapp.cmd` again
36. Verify the application starts with Azure Blob Storage integration
37. Test application functionality at http://localhost:8080
38. Confirm no errors related to storage operations

**Optional: Continue Modernization:**

39. Review other migration tasks in the assessment report
40. Execute additional migrations as time permits
41. Track progress through the `plan.md` and `progress.md` files

## Success Criteria

- ✅ Docker Desktop is running and containers are functional
- ✅ Asset Manager application cloned and runs locally
- ✅ AppCAT assessment completed successfully
- ✅ Assessment identifies 9 cloud readiness issues and 4 Java upgrade opportunities
- ✅ AWS S3 to Azure Blob Storage migration executed via guided task
- ✅ Maven/Gradle dependencies updated with Azure SDK
- ✅ Application configuration migrated to Azure Blob Storage
- ✅ All validation stages pass (CVE, build, consistency, tests)
- ✅ Modernized application runs successfully locally
- ✅ Migration changes tracked in dedicated branch for rollback capability

## Learning Resources

- [GitHub Copilot for VS Code](https://code.visualstudio.com/docs/copilot/overview)
- [Azure SDK for Java](https://learn.microsoft.com/azure/developer/java/sdk/)
- [Migrate from AWS to Azure](https://learn.microsoft.com/azure/architecture/aws-professional/)
- [Azure Blob Storage for Java](https://learn.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-java)
- [Spring Cloud Azure](https://learn.microsoft.com/azure/developer/java/spring-framework/)
- [AppCAT Assessment Tool](https://learn.microsoft.com/azure/developer/java/migration/migration-toolkit-intro)
