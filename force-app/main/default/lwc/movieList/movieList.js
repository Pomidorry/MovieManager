import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAllMovies from '@salesforce/apex/MovieListController.getAllMovies';
import getGenres from '@salesforce/apex/MovieListController.getGenres';

export default class MovieComponent extends NavigationMixin(LightningElement) {
    @track result = [];
    @track filteredMovies = [];
    @track selectedMovie = {};
    @track genres = ['All'];
    @track selectedGenre = 'All';
    @track movieLimit = 20; 
    @track offset = 0;
    @track hasMoreRecords = true;
    @track searchTerm = '';

    connectedCallback() {
        this.fetchMovies();
        this.fetchGenres();
    }

    fetchMovies() {
        getAllMovies({ offset: this.offset, lim: this.movieLimit, genre: this.selectedGenre, searchTerm: this.searchTerm })
            .then((response) => {
                this.result = [...this.result, ...this.formatMovieData(response)];
                this.hasMoreRecords = response.length === this.movieLimit;
            })
            .catch((error) => {
                console.error('Error fetching movies:', error);
            });
    }

    fetchGenres() {
        getGenres()
            .then((response) => {
                this.genres = ['All', ...response];
            })
            .catch((error) => {
                console.error('Error fetching genres:', error);
            });
    }

    formatMovieData(movies) {
        return movies.map((movie) => {
            const genres = movie.Genre__c 
                ? movie.Genre__c.split(';').map(genre => genre.replace('_', ' ')) 
                : ['Genre not available'];
                
            return {
                ...movie,
                id: movie.Id,
                title: movie.Title__c,
                rating: movie.Rating_Calculated__c,
                genres,
                posterUrl: movie.Poster_URL__c && movie.Poster_URL__c.trim() && !movie.Poster_URL__c.includes("null") 
                    ? movie.Poster_URL__c 
                    : 'https://cdn-icons-png.flaticon.com/512/16/16428.png',
                isHorror: genres.includes('Horror'),
                details: movie.Description__c
            };
        });
    }

    handleGenreChange(event) {
        this.selectedGenre = event.target.value;
        this.resetMovies();
    }

    handleSearchInputChange(event) {
        this.searchTerm = event.target.value;
        this.resetMovies();
    }

    resetMovies() {
        this.offset = 0;
        this.result = [];
        this.fetchMovies();
    }

    filterMovies() {
        this.filteredMovies = this.selectedGenre === 'All'
            ? this.result
            : this.result.filter(movie => movie.genres.includes(this.selectedGenre));
    }

    showMore() {
        this.offset = this.result.length;
        this.fetchMovies();
    }

    redirectToRecPage(event) {
        const recId = event.currentTarget.dataset.itemId;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: 'Movie__c',
                actionName: 'view'
            }
        });
    }

    scrollToTop() {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
}
