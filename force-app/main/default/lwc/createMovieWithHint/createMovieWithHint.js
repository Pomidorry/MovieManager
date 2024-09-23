import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchMovies from '@salesforce/apex/MovieAddController.searchMovies';
import createMovieRecord from '@salesforce/apex/MovieAddController.createMovieRecord';

export default class MovieSearchQuickAction extends LightningElement {
    @track searchResults = [];
    @track searchTerm = '';
    @track selectedMovieId = '';
    @track selectedMovieTitle = '';
    @api recordId; 

    searchTimeout;

    handleSearchChange(event) {
        clearTimeout(this.searchTimeout);
        this.searchTerm = event.target.value;

        this.searchTimeout = setTimeout(() => {
            if (this.searchTerm) {
                searchMovies({ title: this.searchTerm })
                    .then(result => {
                        this.searchResults = result.map(movie => {
                            return {
                                ...movie,
                                className: movie.id === this.selectedMovieId ? 'selected' : ''
                            };
                        });
                    })
                    .catch(error => {
                        console.error('Error during movie search:', error);
                    });
            }
        }, 300);
    }

    handleSelectMovie(event) {
        this.selectedMovieId = event.target.value;
        this.selectedMovieTitle = event.target.dataset.title;
        this.searchTerm = this.selectedMovieTitle; // Fill the search input
        
        // Update searchResults to reflect the new selected movie
        this.searchResults = this.searchResults.map(movie => {
            return {
                ...movie,
                className: movie.id === this.selectedMovieId ? 'selected' : ''
            };
        });
    }

    handleCreateMovie() {
        if (this.selectedMovieId) {
            createMovieRecord({ movieId: this.selectedMovieId, parentRecordId: this.recordId })
                .then(() => {
                    this.showToast('Success', 'Movie added successfully', 'success');
                    this.resetForm();
                })
                .catch(error => {
                    console.error('Error during movie creation:', error);
                    this.showToast('Error', 'Error creating movie', 'error');
                });
        } else {
            this.showToast('Warning', 'Please select a movie before creating a record', 'warning');
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    resetForm() {
        this.searchTerm = '';
        this.selectedMovieId = '';
        this.selectedMovieTitle = '';
        this.searchResults = [];
    }
}
