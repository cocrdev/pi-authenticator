/*
 * privacyIDEA Authenticator
 *
 * Author: Frank Merkel <frank.merkel@netknights.it>
 *
 * Copyright (c) 2025 NetKnights GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'package:flutter/material.dart' show WidgetsBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/logger.dart';

abstract class StreamNotifierListener<T extends StreamNotifier<S>, S> {
  final String listenerName;
  final StreamNotifierProvider<T, S> provider;
  final void Function(WidgetRef ref, AsyncValue<S>? previous, AsyncValue<S> next) onNewState;
  const StreamNotifierListener({required this.provider, required this.onNewState, required this.listenerName});
  void buildListen(WidgetRef ref) {
    Logger.debug('("$listenerName") listening to provider ("$provider")');
    ref.listen(provider, (previous, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onNewState(ref, previous, next));
    });
  }
}
