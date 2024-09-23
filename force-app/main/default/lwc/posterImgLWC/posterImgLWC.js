import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const fields = ['Movie__c.Poster_URL__c'];

export default class MoviePosterComponent extends LightningElement {
   @api recordId;  
   posterUrl;
   error;

   @wire(getRecord, { recordId: '$recordId', fields })
   wiredMovie({ error, data }) {
      if (data) {
         this.posterUrl = data.fields.Poster_URL__c.value;
         this.error = undefined;
      } else if (error) {
         this.error = error;
         this.posterUrl = undefined;
      }
   }
}
