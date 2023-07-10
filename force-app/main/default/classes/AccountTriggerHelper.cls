public class AccountTriggerHelper {
    static final String CONT_LAST_NAME = 'Customer Representative';
    public static void createDefaultCustomerContact(List <Account> accList, Map <Id,Account> oldAccMap){
        List<Contact> contactsToBeCreated = new List<Contact>();
        Set<Id> accIdSet =  new Set<Id>();
        for(Account acc : accList){
            if(acc.type != null && acc.type.contains('Customer') && acc.Active__c == true && (oldAccMap != null ? oldAccMap.get(acc.Id).Active__c != acc.Active__c : true)){
                accIdSet.add(acc.Id);
            }
        }
        if(accIdSet.size() > 0){
            Set<Id> eligibleAccIds = getAccountsWithoutDefaultContact(accIdSet);
            for(Account acc : accList){
                if(eligibleAccIds != null && eligibleAccIds.size() > 0){
                    if(eligibleAccIds.contains(acc.Id)){
                        Contact custContact = new Contact();
                        custContact.AccountId = acc.Id;
                        custContact.FirstName = acc.Name;
                        custContact.LastName = CONT_LAST_NAME;
                        custContact.Email = acc.Company_Email__c;
                        custContact.Phone = acc.Phone;
                        contactsToBeCreated.add(custContact);
                    }
                }
            }
        }
        
        if(contactsToBeCreated.size() > 0){
            insert contactsToBeCreated;
        }
    }
    
    public static Set<Id> getAccountsWithoutDefaultContact(Set<Id> accIdSet){
        Set<Id> eligibleAccIds = new Set<Id>();
        for(Account acc : [SELECT Id, Name, (SELECT Id FROM Contacts WHERE LastName = :CONT_LAST_NAME) FROM Account WHERE Id IN :accIdSet]){
            if(acc.Contacts.size()>0){
                continue;
            }
            eligibleAccIds.add(acc.Id);
        }
        if(eligibleAccIds.size() > 0){
           return eligibleAccIds;
        }
        return null;
    }
}