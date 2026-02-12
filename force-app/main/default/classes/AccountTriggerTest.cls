@istest
public with sharing class AccountTriggerTest {
    @TestSetup
    static void makeData(){
    Account Acc1=new Account(Name='Test Account',BillingCountry='India',Company_Name__c='Test Company',Is_Duplicate__c=false);
    insert Acc1;
    Account Acc2=new Account(Name='Test Account 2',BillingCountry='India',Company_Name__c='TestCompany2',Is_Duplicate__c=false);
    insert Acc2;
}

    @istest
    static void testAccountTrigger(){
         Account Acc1=new Account(Name='Test Account',BillingCountry='India',Company_Name__c='Test Company',Is_Duplicate__c=false);
        insert Acc1;
         Test.startTest();
         AccountHelper.updateDescription(Acc1);
         Test.stopTest();
        // Account acc = [SELECT Id, Name,Description, BillingCountry FROM Account WHERE Name='Test Account'];
        
        // Test.startTest();
        // acc.BillingCountry = 'India';
        // update acc;
        // Test.stopTest();
        // Account acc1 = [];
        // System.Assert.areEqual('This is an Indian Account', acc.Description);
    }
    @istest
    static void testAccountTrigger2(){
        Account acc = [SELECT Id, Name, BillingCountry FROM Account WHERE Name='Test Account'];
        Test.startTest();
        acc.Name = 'Test Account 2';
        update acc;
        AccountHelper.validateNameChange(acc, acc);
        Test.stopTest();
        //System.Assert.areEqual('Test Account', acc.Name);
    }
    @istest
    static void testAccountTrigger3(){
        Account acc = [SELECT Id, Name, BillingCountry, Company_Name__c FROM Account WHERE Name='Test Account'];
        Test.startTest();
        AccountHelper.getCompanyCounts(new List<Account>{acc});
        Test.stopTest();
        //System.Assert.areEqual(true, acc.Is_Duplicate__c);
    }
    @istest
    static void testAccountTrigger4(){
        Account acc = [SELECT Id, Name, BillingCountry, Company_Name__c FROM Account WHERE Name='Test Account'];
        Test.startTest();
        AccountHelper.checkDuplicate(acc, new Map<String, Integer>{'Test Company' => 2});
        Test.stopTest();
       // System.Assert.areEqual(true, acc.Is_Duplicate__c);
    }
    @istest
    static void testAccountTrigger5(){
        Account acc = [SELECT Company_Name__c,Is_Duplicate__c FROM Account WHERE Is_Duplicate__c = false Limit 1];
        test.startTest();
        AccountHelper.processAsyncDuplicateUpdates(new Set<String>{'Test Company'});
        Test.stopTest();
        //System.Assert.areEqual(False, acc.Is_Duplicate__c);
    }
}