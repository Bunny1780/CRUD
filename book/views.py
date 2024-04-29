from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST
from .models import Book

# Create your views here.
def home(request):
    book = Book.objects.all
    return render(request, "books/index.html", {"books":book})

def new(request):
    return render(request, "books/new.html")

@require_POST
def create(request):
    book = Book(
        name = request.POST['name'],
        kind = request.POST['kind'],
        note = request.POST['note']
    )
    book.save()

    return redirect("books:home")

def show(request, id):
    book = get_object_or_404(Book, pk = id)

    if request.method == "POST":
        book.name = request.POST['name']
        book.kind = request.POST['kind']
        book.note = request.POST['note']

        book.save()
        return redirect(f'/{id}')
    else:
        return render(request, "books/show.html", {"book":book})
    
def edit(request, id):
    book = get_object_or_404(Book, pk = id)
    return render(request, "books/edit.html", {"book":book})

def delete(request, id):
    book = get_object_or_404(Book, pk = id)
    book.delete()

    return redirect('books:home')