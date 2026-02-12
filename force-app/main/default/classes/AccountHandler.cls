public class AccountHandler implements ITrigger {
    // Context variables to share state between Bulk and Record methods
    private Map<String, Integer> existingCompanyCountMap = new Map<String, Integer>();
    private Set<String> companyNamesForAsyncUpdate = new Set<String>();
 
    // BULK METHODS
    public void bulkBefore() {
        // Delegate the complex SOQL/Map creation to the Helper
        if (Trigger.isInsert) {
            existingCompanyCountMap = AccountHelper.getCompanyCounts((List<Account>)Trigger.new);
        }
    }
 
    public void bulkAfter() {
    }
 
    // BEFORE TRIGGER METHODS
 
    public void beforeInsert(SObject so) {
        Account newAcc = (Account)so;
        // Description Logic
        AccountHelper.updateDescription(newAcc);
 
        // Duplicate Check Logic
        AccountHelper.checkDuplicate(newAcc, existingCompanyCountMap);
    }
 
    public void beforeUpdate(SObject oldSo, SObject so) {
        // Name Validation Logic
        AccountHelper.validateNameChange((Account)so, (Account)oldSo);
    }
 
    public void beforeDelete(SObject so) {
    }
   
    // AFTER TRIGGER METHODS
 
    public void afterInsert(SObject so) {
        Account newAcc = (Account)so;
        // Collect names for Async Processing
        if (newAcc.Company_Name__c != null && newAcc.Is_Duplicate__c == true) {
            companyNamesForAsyncUpdate.add(newAcc.Company_Name__c);
        }
    }
 
    public void afterUpdate(SObject oldSo, SObject so) {
    }
 
    public void afterDelete(SObject so) {
    }
 
    // FINALLY
    public void andFinally() {
        // Execute Async Logic via Helper
        AccountHelper.processAsyncDuplicateUpdates(companyNamesForAsyncUpdate);
    }
}