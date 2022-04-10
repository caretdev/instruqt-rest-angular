import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { of } from 'rxjs';
import { environment } from 'src/environments/environment';

export interface Bookmark {
  url: string;
  description: string;
  dateAdded: string;
  timeAdded: string;
}

const SAMPLE_DATA: Bookmark[] = [
  {url: 'https://community.intersystems.com', description: 'Sample: Development Community', dateAdded: '01/01/2016', timeAdded:'01:01'},
  {url: 'https://openexchange.intersystems.com', description: 'Sample: Open Exchange', dateAdded: '01/01/2019', timeAdded:'02:02'},
];

/**
 * @title Basic use of `<table mat-table>`
 */
 @Component({
  selector: 'app-bookmark-list',
  templateUrl: './bookmark-list.component.html',
  styleUrls: ['./bookmark-list.component.css']
})
export class BookmarkListComponent implements OnInit {
  displayedColumns: string[] = ['description', 'url', 'dateAdded', 'timeAdded'];
  dataSource = null;

  constructor(private http:HttpClient) { }

  ngOnInit(): void {
    this.dataSource=of(SAMPLE_DATA);
  }
}
