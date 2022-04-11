import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { environment } from 'src/environments/environment';
import { tap, catchError, switchMap } from 'rxjs/operators';
import { of } from 'rxjs';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-bookmark-form',
  templateUrl: './bookmark-form.component.html',
  styleUrls: ['./bookmark-form.component.css']
})
export class BookmarkFormComponent implements OnInit {
  url='';
  description='';

  constructor(private http:HttpClient, private snackBar: MatSnackBar) { }

  ngOnInit(): void {
  }

  addBookmark(): void {
    this.http.post(environment.API_URL+'/add',{url:this.url, description:this.description}).pipe(
      switchMap(()=>this.snackBar.open('New URL added', 'OK').afterDismissed()),
      tap(()=>window.location.reload()),
      catchError(()=>this.snackBar.open('Something went wrong', 'OK').afterDismissed()),
    ).subscribe()
  }

}
