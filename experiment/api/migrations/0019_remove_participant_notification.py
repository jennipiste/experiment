# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2018-06-18 12:40
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0018_auto_20180618_1036'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='participant',
            name='notification',
        ),
    ]