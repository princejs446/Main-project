import 'package:appwrite/models.dart';

class Note {
  final String title;
  final String description;


  Note({
 
    required this.title,
    required this.description,
  
    
  });

  factory Note.fromDocument(Document doc) {
    return Note(
      
      title: doc.data['title'],
      description: doc.data['description'],
 
    );
  }
}