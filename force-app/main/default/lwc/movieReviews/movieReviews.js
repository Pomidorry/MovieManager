import { LightningElement, api, wire, track } from 'lwc';
import getReviews from '@salesforce/apex/MovieReviewController.getReviews';
import TMDB_ID_FIELD from '@salesforce/schema/Movie__c.TMDB_id__c';
import { getRecord } from 'lightning/uiRecordApi';

export default class MovieReviews extends LightningElement {
    @api recordId;
    reviews = [];
    successMessage = '';
    errorMessage = '';
    isModalOpen = false;
    @track selectedReview = {};

    @wire(getRecord, { recordId: '$recordId', fields: [TMDB_ID_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            const tmdbIdField = data.fields.TMDB_id__c;
            if (tmdbIdField && tmdbIdField.value) {
                this.fetchReviews(tmdbIdField.value);
            } else {
                this.errorMessage = 'TMDB ID field is missing or not populated';
            }
        } else if (error) {
            this.errorMessage = 'Failed to load the movie record';
            console.error(error);
        }
    }

    fetchReviews(tmdbId) {
        getReviews({ movieId: tmdbId })
            .then(response => {
                this.formatReviewData(response);

            })
            .catch(error => {
                this.errorMessage = 'Failed to fetch movie reviews';
                console.error(error);
            });
    }

    formatReviewData(reviews) {
        this.reviews = reviews.map(item => ({
            id: item.id,
            author: item.author,
            content: this.truncateContent(item.content),
            fullContent: item.content, 
            created_at: item.created_at,
        }));
    }

    truncateContent(content) {
        const maxLength = 100; // Maximum length for preview
        return content.length > maxLength ? content.substring(0, maxLength) + '...' : content;
    }

    handleReadMore(event) {
        const reviewId = event.target.dataset.id;
        this.selectedReview = this.reviews.find(review => review.id === reviewId);
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.selectedReview = {};
    }
}
