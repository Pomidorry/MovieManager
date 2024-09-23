import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class MovieCard extends NavigationMixin(LightningElement) {
    @api movie;

    redirectToRecPage(event) {
        let recId = event.currentTarget.dataset.itemId;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: 'Movie__c',
                actionName: 'view'
            }
        });
    }
}
