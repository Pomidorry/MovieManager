import { LightningElement, api, wire, track } from 'lwc';
import searchMovies from '@salesforce/apex/MovieAddController.searchMovies';


export default class MovieSearch extends LightningElement {
    @track searchTerm = '';
    @track results=[];
    searchTimeout;
    

    fetchRequestedMovie(event) {
        clearTimeout(this.searchTimeout);
        this.searchTerm = event.target.value;

        this.searchTimeout = setTimeout(() => {
            if (this.searchTerm) {
                searchMovies({ title: this.searchTerm })
                    .then(response => this.formatMovieData(response))
                    .catch(error => console.error('Error during movie search:', error));
            }
        }, 300);
    }
    

    formatMovieData(res) {
        this.results = res.map((item) => {
            let title = item.original_title;  
            let id = item.id;
            let overview = item.overview;
            let rating = item.vote_average;
            let posterUrl = 'https://cdn-icons-png.flaticon.com/512/16/16428.png'; // Default poster
            if (item.poster_path && typeof item.poster_path === 'string' && item.poster_path.trim() !== '') {
                posterUrl = 'https://image.tmdb.org/t/p/w500/' + item.poster_path;
            }
            return { id, title, overview, rating, posterUrl };  
        });
    }


}
