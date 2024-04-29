from django.db import models

# Create your models here.
class Book(models.Model):
    name = models.CharField(max_length=100)
    kind = models.CharField(max_length=20)
    note = models.TextField(default='')