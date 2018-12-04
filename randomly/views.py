from django.http import HttpResponse
import random

def index(request):
    r = random.randint(1, 10)
    return HttpResponse("Randomly says %d" % (r))
