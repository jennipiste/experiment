from django.conf.urls import url
from experiment.api.views import ParticipantListCreateAPIView, ParticipantChatDialogListCreateAPIView
from experiment.api.views import ParticipantChatMessageListCreateAPIView, ChatMessageListCreateAPIView
from experiment.api.views import ChatDialogUpdateAPIView, ParticipantQuestionnaireCreateAPIView

urlpatterns = [
    url(r'api/participants/?$', ParticipantListCreateAPIView.as_view()),
    url(r'api/participants/(?P<participant_id>[\d]+)/dialogs/(?P<dialog_id>[\d]+)/messages/?$', ParticipantChatMessageListCreateAPIView.as_view()),
    url(r'api/participants/(?P<participant_id>[\d]+)/dialogs/?$', ParticipantChatDialogListCreateAPIView.as_view()),
    url(r'api/participants/(?P<participant_id>[\d]+)/questionnaires/?$', ParticipantQuestionnaireCreateAPIView.as_view()),
    url(r'api/dialogs/(?P<dialog_id>[\d]+)/?$', ChatDialogUpdateAPIView.as_view()),
    url(r'api/dialogs/(?P<dialog_id>[\d]+)/messages/?$', ChatMessageListCreateAPIView.as_view()),
]
