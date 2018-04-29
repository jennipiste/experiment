from django.conf.urls import url
from experiment.api.views import ParticipantListCreateAPIView, ChatDialogListCreateAPIView
from experiment.api.views import ParticipantChatMessageListCreateAPIView, ChatMessageListCreateAPIView

urlpatterns = [
    url(r'api/participants/?$', ParticipantListCreateAPIView.as_view()),
    url(r'api/participants/(?P<participant_id>[\d]+)/dialogs/(?P<dialog_id>[\d]+)/messages/?$', ParticipantChatMessageListCreateAPIView.as_view()),
    url(r'api/participants/(?P<participant_id>[\d]+)/dialogs/?$', ChatDialogListCreateAPIView.as_view()),
    url(r'api/dialogs/(?P<dialog_id>[\d]+)/messages/?$', ChatMessageListCreateAPIView.as_view()),
]
