from django.conf.urls import url
from experiment.api.views import ParticipantListCreateAPIView, ChatDialogListCreateAPIView, ChatMessageListCreateAPIView

urlpatterns = [
    url(r'api/participants', ParticipantListCreateAPIView.as_view()),
    url(r'api/chat_messages', ChatMessageListCreateAPIView.as_view()),
    url(r'api/chat_dialogs', ChatDialogListCreateAPIView.as_view()),
]
