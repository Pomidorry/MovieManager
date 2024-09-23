import { LightningElement, api } from 'lwc';
import createMovieRecord from '@salesforce/apex/MovieAddController.createMovieRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // Import this

export default class MovieSearchCard extends LightningElement {
    @api movie; 

    handleCreateMovie() {
        createMovieRecord({
            movieId: this.movie.id,
        })
        .then(() => {
            this.showToast('Success', 'Movie added successfully', 'success');
        })
        .catch((error) => {
            this.showToast('Error', 'a', 'error');
        });
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}
