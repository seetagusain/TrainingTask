
public class InvokableMergeDuplicate {
    public class FlowInput {
        @InvocableVariable(label='Account Id' required=true)
        public Id recordId;
    }
    @InvocableMethod(label='Merge Duplicate Accounts' description='Moves contacts from duplicate account and deletes it')
    public static void mergeDuplicatedemo(List<FlowInput> inputs){
        if (inputs==null||inputs.isEmpty()) {
            return;
        }
        string currentAccId=inputs[0].recordId;
        System.debug('Current Account Id:'+currentAccId);
        Account currentAcc=[Select Id,Company_Name__c from Account where Id=:currentAccId];
        system.debug('CurrentAcc===:'+currentAcc);
        List<Account> duplicateAccsList=[Select Id,Company_Name__c from Account where Company_Name__c=:currentAcc.Company_Name__c AND Id!=:currentAccId AND Is_Duplicate__c=true];
        system.debug('duplicateAccsList===:'+duplicateAccsList);
        if (duplicateAccsList.isEmpty())
        {
            return;
        }
        Account DupAcc=duplicateAccsList[0];
        List<Contact> ContactsToUpdate=[Select Id,AccountId from Contact where AccountId=:DupAcc.Id];
        for (Contact con : ContactsToUpdate) {
            con.AccountId=currentAccId;
        }
        if (!ContactsToUpdate.isEmpty()) {
            Update ContactsToUpdate;
            delete DupAcc;
        }
        
    }
}