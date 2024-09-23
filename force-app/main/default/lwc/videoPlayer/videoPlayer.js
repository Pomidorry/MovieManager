import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

import VIDEO_ID_FIELD from '@salesforce/schema/Movie__c.VideoUrl__c';

export default class YoutubeVideoPlayer extends LightningElement {
    @api recordId; 

    @wire(getRecord, { recordId: '$recordId', fields: [VIDEO_ID_FIELD] })
    record;

    get videoUrl() {
        const videoId = this.record.data?.fields.VideoUrl__c.value;
        return videoId ? `https://www.youtube.com/embed/${videoId}` : '';
    }
}
