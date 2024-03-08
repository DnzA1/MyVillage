import { LightningElement, api } from 'lwc';
import postMethod from '@salesforce/apex/OutBoundLog.postMethod';

export default class CallOutBound extends LightningElement {

    @api recordId;
    calloutPath;
    isShow= false;

    clickHandler(){
        postMethod({recordId: this.recordId})
        .then(result =>{
            this.calloutPath= "https://"+window.location.host+"/"+result.Id;
            this.isShow = true;
        }).catch(error => {
            if (Array.isArray(error.body)) {
                this.errors = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.errors = error.body.message;
            }
        });

    }

} 