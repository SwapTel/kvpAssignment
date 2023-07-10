@isTest
private class AccountTriggerHelper_Test{
	@TestSetup 
	private static void createTestData() {
		List<Account> accList = new List<Account>();
		Account acc1 = new Account(Name = 'DummyCompany',
						type = 'Customer - Direct',
						Phone = '123456789',
						Company_Email__c = 'testemail@dummycompany.com');
		accList.add(acc1);		
		insert accList;
	}
    @isTest
    private static void createDefaultCustomerContact_InsertTest(){
        Account acc1 = new Account(Name = 'DummyCompany2',
						type = 'Customer - Direct',
						Phone = '123456789',
						Company_Email__c = 'testemail@dummycompany.com',
                        Active__c = TRUE);
        
		Test.startTest();
		insert acc1;
		List<Contact> conList = [SELECT Id, Name FROM Contact WHERE AccountId = :acc1.Id AND LastName = 'Customer Representative' AND Phone =:acc1.Phone AND Email = :acc1.Company_Email__c];
		System.assertEquals(1,conList.size());
        Test.stopTest();
    }
    @isTest
    private static void createDefaultCustomerContact_UpdateTest(){
        Account acc1 = [SELECT Id, Active__c, Phone, Company_Email__c  FROM Account WHERE Name = 'DummyCompany'];
        acc1.Active__c=true;
		Test.startTest();
		update acc1;
		
		List<Contact> conList = [SELECT Id, Name FROM Contact WHERE AccountId = :acc1.Id AND LastName = 'Customer Representative' AND Phone =:acc1.Phone AND Email = :acc1.Company_Email__c];
		System.assertEquals(1,conList.size());
        Test.stopTest();
    }
    
    @isTest
    private static void createDefaultCustomerContact_WithContactTest(){
        Account acc1 = [SELECT Id, Name, Active__c, Phone, Company_Email__c  FROM Account WHERE Name = 'DummyCompany'];
        Contact cont =  new Contact(
        				FirstName = acc1.Name,
        				LastName = 'Customer Representative',
            			AccountId = acc1.Id,
        				Phone = '7890000',
        				Email = 'testemail@test.com');
        insert cont;
        acc1.Active__c = TRUE;
        update acc1;
		Test.startTest();
		List<Contact> conList = [SELECT Id, Name FROM Contact WHERE AccountId = :acc1.Id AND LastName = 'Customer Representative' AND Phone =:acc1.Phone AND Email = :acc1.Company_Email__c];
		System.assertEquals(0,conList.size());
        Test.stopTest();
    }
    
}