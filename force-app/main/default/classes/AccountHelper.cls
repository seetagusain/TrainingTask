public inherited sharing class AccountHelper {
 
    /*** Updates the Account Description if the Country is India.*/

    public static void updateDescription(Account acc) {
        if (acc.BillingCountry != null && acc.BillingCountry.equalsIgnoreCase('India')) {
            acc.Description = 'This is an Indian Account';
        } else {
            acc.Description = null;
        }

    }
 
    /*** Validates that the Account Name is not reverted to a previous value.*/

    public static void validateNameChange(Account newAcc, Account oldAcc) {
        if (newAcc.Name != oldAcc.Name) {
            // Check if the new name matches the stored "Old Name"
            if (newAcc.Name == oldAcc.Old_Account_Names__c) {
                newAcc.Name.addError('You cannot change the account name to its previous value.');
            }
            // Store the previous name before the update commits
            newAcc.Old_Account_Names__c = oldAcc.Name;
        }
    }
 
    /*Prepares a Map of existing company counts based on the incoming list.
     Used in the Bulk phase to avoid SOQL in loops.*/

    public static Map<String, Integer> getCompanyCounts(List<Account> scopeAccounts) {
        Map<String, Integer> countMap = new Map<String, Integer>();
        Set<String> companyNames = new Set<String>();
        for (Account acc : scopeAccounts) {
            if (acc.Company_Name__c != null) {
                companyNames.add(acc.Company_Name__c);
            }
        }
        if (!companyNames.isEmpty()) {
            List<AggregateResult> results = [
                SELECT Company_Name__c, COUNT(Id) c 
                FROM Account 
                WHERE Company_Name__c IN :companyNames 
                GROUP BY Company_Name__c
            ];
            for (AggregateResult ar : results) {
                countMap.put((String)ar.get('Company_Name__c'), (Integer)ar.get('c'));
            }
        }
        return countMap;
    }
 
    /* Checks if the account is a duplicate based on the pre-loaded map.*/

    public static void checkDuplicate(Account newAcc, Map<String, Integer> existingCounts) {
        if (newAcc.Company_Name__c != null) {
            Integer count = existingCounts.containsKey(newAcc.Company_Name__c) 
                            ? existingCounts.get(newAcc.Company_Name__c) 
                            : 0;
            if (count > 2) {
                newAcc.addError('Company name already exist in 2 accounts');
            } else if (count >= 1) {
                newAcc.Is_Duplicate__c = true;
            }
        }
    }
 
    /*Finds original accounts and enqueues the job to mark them as duplicates.
    */

    // public static void processAsyncDuplicateUpdates(Set<String> companyNames) {
    //     if (!companyNames.isEmpty()) {
    //         List<Account> oldAccountList = [
    //             SELECT Id, Company_Name__c, Is_Duplicate__c 
    //             FROM Account 
    //             WHERE Company_Name__c IN :companyNames 
    //             AND Is_Duplicate__c = false
    //         ];
    //         if (!oldAccountList.isEmpty()) {
    //             System.enqueueJob(new DuplicateMarkQueueable(oldAccountList));
    //         }
    //     }

    // }

    public static void processAsyncDuplicateUpdates(Set<String> companyNames){
            if (!companyNames.isEmpty()) {
            List<Account> oldAccountList = [SELECT Id, Company_Name__c,Is_Duplicate__c 
                                            FROM Account 
                                            WHERE Company_Name__c 
                                            IN :companyNames 
                                            AND Is_Duplicate__c = false];
                if(!oldAccountList.isEmpty()){
                    for (Account accnt : oldAccountList) {
                        accnt.Is_Duplicate__c = true;
                    }
                    update oldAccountList;
                }
        }
    }
}