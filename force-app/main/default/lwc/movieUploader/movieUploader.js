import { LightningElement, track } from 'lwc';
import uploadMovieRecords from '@salesforce/apex/MovieUploaderController.uploadMovieRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MovieUploader extends LightningElement {
    @track movieCount = 0;
    @track isCreateDisabled = true;
    uploadedFileContent = null;

    handleUploadFinished(event) {
        const file = event.target.files[0];

        if (file) {
            const reader = new FileReader();
            reader.onload = () => this.processFile(reader.result);
            reader.readAsText(file);
        }
    }

    processFile(fileContent) {
        try {
            const jsonData = JSON.parse(fileContent);
            this.uploadedFileContent = fileContent;
            this.movieCount = jsonData.length;
            this.isCreateDisabled = false;
        } catch (error) {
            this.showToast('Error', 'Invalid JSON file format', 'error');
        }
    }

    handleCreateRecords() {
        if (this.uploadedFileContent) {
            uploadMovieRecords({ jsonBody: this.uploadedFileContent })
                .then(() => this.resetUploader('Success', 'Movie records created successfully', 'success'))
                .catch(error => this.showToast('Error', error.body.message, 'error'));
        }
    }

    resetUploader(title, message, variant) {
        this.isCreateDisabled = true;
        this.movieCount = 0;
        this.uploadedFileContent = null;
        this.showToast(title, message, variant);
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
