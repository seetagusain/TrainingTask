trigger triggerOnAccount on Account (before insert, before update, before delete, after insert, after update, after delete) {

    // The Factory handles checking if the trigger is active and finding the correct handler
    TriggerFactory.initiateHandler(Account.sObjectType);

}
 