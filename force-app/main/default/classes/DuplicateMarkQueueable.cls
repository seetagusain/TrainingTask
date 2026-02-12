public class DuplicateMarkQueueable implements Queueable {
    // private List<Account> accList;
    // public DuplicateMarkQueueable(List<Account> accList){
    //     this.accList = accList;
    // }
    // public void execute(QueueableContext qc){
    //     List<Account> toUpdate = new List<Account>();
    //     // Create new instances to update to ensure we don't hit read-only errors
    //     // or update fields we didn't intend to.
    //     for (Account acc : accList) {
    //         Account a = new Account(Id = acc.Id);
    //         a.Is_Duplicate__c = true;
    //         toUpdate.add(a);
    //     }
    //     if (!toUpdate.isEmpty()) {
    //         update toUpdate;
    //     }
    // }
}