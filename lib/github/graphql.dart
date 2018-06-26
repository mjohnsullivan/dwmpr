// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:dwmpr/github/parsers.dart';
import 'package:dwmpr/github/pullrequest.dart';
import 'package:dwmpr/github/repository.dart';
import 'package:dwmpr/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'package:dwmpr/github/token.dart';
import 'package:dwmpr/github/user.dart';
import 'package:dwmpr/github/serializers.dart';

const url = 'https://api.github.com/graphql';
const headers = {'Authorization': 'bearer $token'};

/// Fetches user data from Github
Future<User> user() async {
  const query = '''
    query GetUser {
      viewer {
        login
        name
        location
        company
        avatarUrl
      }
    }''';
  final result = await _makeCall(query);
  final parsedResult = json.decode(result);
  final user = serializers.deserializeWith(
      User.serializer, parsedResult['data']['viewer']);
  return user;
}

/// Fetches all PR review requests for the logge in user
Future<List<PullRequest>> openPullRequestReviews(String login) async {
  final query = '''
    query GetOpenReviewRequests {
      search(query: "type:pr state:open review-requested:$login", type: ISSUE, first: 100) {
        issueCount
        pageInfo {
          endCursor
          startCursor
        }
        edges {
          node {
            ... on PullRequest {
              repository {
                name
                url
                forkCount
                stargazers(first: 1) {
                  totalCount
                }
              }
              title
              number
              url
            }
          }
        }
      }
    }''';
  final result = await _makeCall(query);
  return parseopenPullRequestReviews(result);
}

/// Fetches a user's repos
Future<List<Repository>> repositories() async {
  final query = '''
    query GetRepositories {
      viewer {
        repositories(first:100) {
          edges {
            node {
              name
              description
              url
              forkCount
              stargazers(first: 1) {
                totalCount
              }
            }
          }
        }
      }
    }''';
  final result = await _makeCall(query);
  print(result);
  return parseRepositories(result);
}

/// Sends a GraphQL query to Github and returns raw response
Future<String> _makeCall(String query) async {
  final gqlQuery = json.encode({'query': removeSpuriousSpacing(query)});
  final response = await http.post(url, headers: headers, body: gqlQuery);
  if (response.statusCode == 200)
    return response.body;
  else
    throw Exception('Error: ${response.statusCode}');
}
